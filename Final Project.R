library(jsonlite)

# Adzuna, 50 results, jobs in us, full time, data science
Adzuna_file <- jsonlite::fromJSON("https://api.adzuna.com/v1/api/jobs/us/search/1?app_id=018d3e05&app_key=c61bad16e0597343a3b672a6984062a8&results_per_page=100&what_phrase=data%20science&full_time=1", flatten=TRUE)
View(Adzuna_file$results)

# Github jobs, 8 results, jobs in us, full time, data science
# https://jobs.github.com/positions?utf8=%E2%9C%93&description=data+analyst&location=&full_time=on
# https://jobs.github.com/positions?utf8=%E2%9C%93&description=data+science&location=usa&full_time=on
Github_Jobs_file <- jsonlite::fromJSON("https://jobs.github.com/positions.json?utf8=%E2%9C%93&description=data+science&location=usa&full_time=on", flatten=TRUE)
View(Github_Jobs_file)

# The muse
# https://www.themuse.com/api/public/jobs?category=Data%20Science&page=1

Muse_file <- jsonlite::fromJSON("https://www.themuse.com/api/public/jobs?category=Data%20Science&page=1", flatten=TRUE)
View(Muse_file$results)
