#! /bin/csh


# ARF: here we are going to reprocess all the Nback data - it was incorrectly processed the 
# first time around.   28/06/2017
# 

set scripts_loc = `pwd`

set subjs = (RWM002 RWM003 RWM005 RWM008 RWM012 RWM013 RWM015 RWM016 RWM018 RWM022 RWM006 \
RWM007 RWM010 RWM017 RWM019 RWM020 RWM021 RWM023 )


set visits = (visit1 visit2)

foreach subj (${subjs})
foreach visit (${visits})

	cd ${scripts_loc}
	./proc.REDO.Nback.tcsh ${subj} ${visit}

end
end



