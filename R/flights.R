#' Import flights
#' @param years years integer vector
#' @param months months integer vector
#' @rdname flights
#' @export
import_flights <- \(years = 2024:2025, months = 1:12) {
  download_flights(years, months) |>
    prepare_flights() |>
    load_flights()
}

#' Prepare flights
#' @param files flights files
#' @rdname flights
#' @export
prepare_flights <- \(files = NULL, years = NULL, months = NULL) {
  if (is.null(files) && (is.null(years) || is.null(months))) {
    stop("Provide the downloaded files or the years and months to load.")
  }
  if (!is.null(files)) {
    files_basename <- basename(files)
    cleaned_basename <- list.files(here::here("data", "load")) |>
      basename()
  } else {
    files_basename <-
      files_by_year_months(
        list.files(here::here("data", "raw")),
        pattern = "On_Time_Reporting_Carrier_%Y_%m.zip",
        years,
        months
      )
    cleaned_basename <-
      files_by_year_months(
        list.files(here::here("data", "load")),
        pattern = "On_Time_Reporting_Carrier_%Y_%m.parquet",
        years,
        months
      ) |>
      basename()
  }

  missing <- !files_basename %in% gsub("\\.parquet", "\\.zip", cleaned_basename)
  to_clean <- files_basename[missing]
  if (length(to_clean) > 0) {
    purrr::walk(
      .progress = TRUE,
      here::here("data", "raw", basename(to_clean)),
      clean_flights
    )
  }

  here::here("data", "load", list.files(here::here("data", "load"))) |>
    invisible()
}

#' Download flights
#' @rdname flights
#' @export
download_flights <- \(years = 2025, months = 1:12) {
  fs::dir_create(here::here("data", "raw"))
  fs::dir_create(here::here("data", "load"))
  files <- fill_year_month(years, months, start = "1987-10-01") |>
    mutate(
      url = paste0(
        "http://transtats.bts.gov/PREZIP/On_Time_Reporting_Carrier_On_Time_Performance_1987_present_",
        .data$year,
        "_",
        .data$month,
        ".zip"
      ),
      file_name = paste0(
        "On_Time_Reporting_Carrier_",
        .data$year,
        "_",
        .data$month,
        ".zip"
      )
    )
  download_if_missing(from = files$url, to = files$file_name)
}

#' Download carriers
#' @rdname flights
#' @export
download_carriers <- \() {
  download_if_missing(
    from = "https://transtats.bts.gov/Download_Lookup.asp?Y11x72=Y_haVdhR_PNeeVRef",
    to = "carriers.csv",
    raw_dir = here::here("data")
  )
}
#' Import carriers
#' @rdname flights
#' @export
import_carriers <- \() {
  download_carriers()
  readr::read_csv(here::here("data", "carriers.csv"), show_col_types = FALSE)
}

#' Load flights
#' @param files flights files
#' @rdname flights
#' @export
load_flights <- \(files) {
  if (!rlang::is_installed("arrow")) {
    return(files |> purrr::map_dfr(nanoparquet::read_parquet))
  }
  open_dataset <- utils::getFromNamespace("open_dataset", "arrow")
  here::here("data", "load") |>
    open_dataset() |>
    collect()
}

#' @noRd
download_safely <- function(url, path, timeout_sec = 3600) {
  message(glue("Saving {url} to {path}"))
  req <- request(url) |>
    req_progress() |>
    req_retry(max_tries = 3) |>
    req_timeout(timeout_sec)

  resp <- try(req_perform(req, path = path), silent = TRUE)

  if (inherits(resp, "try-error")) {
    cond <- attr(resp, "condition")
    if (is.null(cond$resp)) {
      stop(sprintf(
        "Failed: %s returned status %d",
        url,
        cond
      ))
    }
    return(cond$resp)
  }

  resp
}

#' @noRd
fill_year_month <- function(
  years,
  months,
  start = "1870-01-01",
  end = Sys.Date()
) {
  years <- as.numeric(years)
  months <- as.numeric(months)
  start <- as.Date(start)
  end <- as.Date(end)
  filled_year_month <- tibble::tibble(expand.grid(years, months)) |>
    rename(year = .data$Var1, month = .data$Var2) |>
    mutate(
      month_start = lubridate::ymd(paste(
        .data$year,
        .data$month,
        "01",
        sep = "/"
      )),
      month_end = lubridate::ymd(
        ifelse(
          .data$month == 12,
          paste(.data$year + 1, "01/01", sep = "/"),
          paste(.data$year, .data$month + 1, "01", sep = "/")
        )
      ) -
        1
    ) |>
    filter(
      .data$year > 0 & .data$month >= 1 & .data$month <= 12,
      .data$month_start >= start & .data$month_start <= end
    ) |>
    arrange(.data$month_start)
  return(filled_year_month)
}

#' @noRd
extract_filename_date <- function(files, pattern) {
  if (length(files) < 1) {
    return(NULL)
  }
  files |>
    basename() |>
    lubridate::fast_strptime(format = pattern) |>
    as.Date() +
    lubridate::days(1)
}

#' @noRd
files_by_year_months <- function(
  files,
  pattern,
  years = as.numeric(
    format(Sys.Date(), '%Y')
  ),
  months = 1:12,
  ...
) {
  if (length(files) < 1) {
    return(NULL)
  }
  files_df <- tibble::tibble(
    filename = files,
    file_date = extract_filename_date(files, pattern)
  ) |>
    mutate(
      file_year = lubridate::year(.data$file_date),
      file_month = lubridate::month(.data$file_date)
    )
  possible_df <- fill_year_month(years, months)
  selected_df <- files_df |>
    left_join(
      possible_df,
      by = c("file_year" = "year", "file_month" = "month")
    ) |>
    filter(!is.na(.data$month_start))
  return(fs::as_fs_path(selected_df$filename))
}

#' @noRd
download_if_missing <- function(
  from,
  to = basename(from),
  raw_dir = here::here("data", "raw"),
  ...
) {
  if (length(from) != length(to)) {
    stop("src and to must be of the same length")
  }
  files <- file.path(raw_dir, to)
  missing <- !file.exists(files)
  message(paste(
    "Downloading",
    sum(missing),
    "new files. ",
    sum(!missing),
    "untouched."
  ))
  if (any(missing)) {
    purrr::walk2(
      from[missing],
      files[missing],
      .progress = TRUE,
      \(x, y) download_safely(x, y)
    )
  }

  file.path(raw_dir, to)
}

#' @noRd
clean_flights <- function(path_zip) {
  load_dir <- gsub("/raw", "/load", path_zip)
  path_parquet <- load_dir |>
    gsub("\\.zip", "\\.parquet", x = _)
  message(glue("Cleaning {path_parquet}"))
  loaded <-
    readr::read_csv(path_zip, guess_max = Inf, show_col_types = FALSE) |>
    transmute(
      year = .data$Year,
      month = .data$Month,
      day = .data$DayofMonth,
      dep_time = as.numeric(.data$DepTime),
      sched_dep_time = as.numeric(.data$CRSDepTime),
      dep_delay = .data$DepDelay,
      arr_time = as.numeric(.data$ArrTime),
      sched_arr_time = as.numeric(.data$CRSArrTime),
      arr_delay = .data$ArrDelay,
      carrier = .data$Reporting_Airline,
      tailnum = .data$Tail_Number,
      flight = .data$Flight_Number_Reporting_Airline,
      origin = .data$Origin,
      dest = .data$Dest,
      air_time = .data$AirTime,
      distance = .data$Distance,
      cancelled = .data$Cancelled,
      diverted = .data$Diverted,
      hour = .data$sched_dep_time %/% 100,
      minute = .data$sched_dep_time %% 100,
      time_hour = lubridate::make_datetime(
        .data$Year,
        .data$Month,
        .data$DayofMonth,
        .data$hour,
        .data$minute,
        0
      )
    ) |>
    arrange(.data$year, .data$month, .data$day, .data$dep_time)

  loaded |> write_parquet(path_parquet)

  invisible(NULL)
}
