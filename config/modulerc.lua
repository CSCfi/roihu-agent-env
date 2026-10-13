--Add modules that shouldn't be loaded here.
--If the files shouldn't be accessible at all, also add them to BLACKLISTED_APP_DIRS variable in the wrappers.
forbid{name={"molpro", "gaussian", "vasp"}}
forbid{name={"roihu-agent-env"}, message="Loading roihu-agent-env inside its own container will break it."}