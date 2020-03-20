update_cron <- function(path){
  cronR::cron_clear(F)
  ls <- list.files(path = path,pattern = '.R$')
  type <- strsplit(ls,'_') %>% map_chr(~.[[2]]) %>% gsub('.R$','',.)
  position <- which(!type%in%c('not','base'))
  type <- type[position]
  ls <- ls[position]
  fns <- normalizePath(file.path(path,ls))
  logpath <- normalizePath(file.path(path,'log'))
  logs <- file.path(logpath,gsub('R$','log',ls))
  for (i in seq_along(fns)){
    cmd<-cronR::cron_rscript(rscript = fns[[i]],
                             rscript_log =logs[[i]])

    freq_ <- get_cron_freq(type[i])
    cronR::cron_add(command = cmd,
                    frequency = freq_,id = gsub('.R$','',ls[[i]]))
  }
}












