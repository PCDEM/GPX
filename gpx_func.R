make_gpx <- function(infile, ramps_lakes, outfile) {
  
  # ----DESCRIPTION----
  # This code converts and excel/csv file of site coordinates to a GPX files that
  # can uploaded to a GPS unit. This program can only read csv or excel files which
  # MUST have columns labeled 'Name' for the site and 'Lat' and 'Long'. This program
  # creates a text document formatted to GPX "by hand". At the time of writing this 
  # code, there were no packages to convert a file to GPX. A file of boat ramp
  # coordinates is also imported so that their locations can be added to the
  # GPS unit each time the GPX file is uploaded.
  
  # ----USAGE----
  # Update the infile with the excel/csv of coordinates and the outfile with the
  # location and name of the GPX file to be created.
  # # Make GPX file to upload to GPS unit using strata coordinates file:
  #
  #       make_gpx(
  #          infile  = 'coords/2025/BCB Fixed Site Coordinates.xlsx',
  #          ramps_lakes = 'coords/ramps_and_lake_centers.xlsx',
  #          outfile = 'coords/2025/BCB Fixed Site Coordinates.gpx'
  #        )
  
  # ----INPUTS----
  # infile  = excel/csv file of coordinates.
  # ramps_lakes = excel/csv file of boat ramp and lake center coordinates.
  # outfile = Name of GPX file to be created.
  
  # ----OUTPUTS----
  # A GPX text file that can be uploaded to a GPS unit.
  
  # ----AUTHORS:----
  # Alex Manos (3/17/23)
  
  #-----------------------------------------------------------------------------
  
  # Load packages:
  if (!nzchar(system.file(package = "librarian")))
    install.packages("librarian")
  
  librarian::shelf(
    librarian, stringr, readxl, dplyr, cli
  )
  
  cli_h1('Genearting GPX File')
  
  cli_alert_info("Importing coordinates...")

  # Import coordinates for boat ramps:
  extras <- read_excel(ramps_lakes, sheet = 'boat_ramps') |>
    bind_rows(
      read_excel(ramps_lakes, sheet = 'lake_centers') 
    )

  # Read coordinate file based on file type:
  ifelse(
    str_sub(infile, -3) == 'csv', 
    crds <- read.csv(infile), 
    crds <- read_excel(infile)
    )
  
  cli_alert_success("Coordinates imported successfully")
  cli_alert_info('Writing GPX file...')

  # Create gpx file with the header
  write("<gpx>", file = outfile)
  
  # Add boat ramp lat/lngs and waypoint names:
  for (i in 1:nrow(extras)){
    write(c(paste0('<wpt lat="', extras$Lat[i], '" lon="', extras$Long[i], '">'),
            paste0('  <name>', extras$Name[i], '</name>'),
            '</wpt>'), file = outfile, append = TRUE)
  }
  
  # Add ambient lat/lngs and waypoint names:
  for (i in 1:nrow(crds)){
    write(c(paste0('<wpt lat="', crds$Lat[i], '" lon="', crds$Long[i], '">'),
            paste0('  <name>', crds$Name[i], '</name>'),
            '</wpt>'), file = outfile, append = TRUE)
  }
  
  # Add the footer to the gpx file:
  write("</gpx>", file = outfile, append = TRUE)
  
  # Close the file connection
  close(file(outfile))
  
  cli_alert_success('GPX file successfully created')
  
}