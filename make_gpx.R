source('gpx_func.R')

# Make GPX file to upload to GPS unit using strata coordinates file:
make_gpx(
  infile       = 'coords/bcb_even.xlsx',
  ramps_lakes  = 'coords/ramps_and_lake_centers.xlsx',
  outfile      = 'coords/bcb_even.gpx'
)
