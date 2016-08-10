

# 

tests/test-pics-gpu: phantom pics nrmse $(TESTS_OUT)/shepplogan_coil.ra
	set -e; mkdir $(TESTS_TMP) ; cd $(TESTS_TMP)					;\
	$(TOOLDIR)/phantom -S8 coils.ra							;\
	$(TOOLDIR)/pics -g -S -r0.001 $(TESTS_OUT)/shepplogan_coil.ra coils.ra reco1.ra	;\
	$(TOOLDIR)/pics    -S -r0.001 $(TESTS_OUT)/shepplogan_coil.ra coils.ra reco2.ra	;\
	$(TOOLDIR)/nrmse -t 0.000001 reco1.ra reco2.ra					;\
	rm *.ra ; cd .. ; rmdir $(TESTS_TMP)
	touch $@


tests/test-pics-gpu-noncart: traj scale phantom ones pics nrmse
	set -e; mkdir $(TESTS_TMP) ; cd $(TESTS_TMP)					;\
	$(TOOLDIR)/traj -r -x256 -y64 traj.ra						;\
	$(TOOLDIR)/scale 0.5 traj.ra traj2.ra						;\
	$(TOOLDIR)/phantom -t traj2.ra ksp.ra						;\
	$(TOOLDIR)/ones 3 128 128 1 o.ra						;\
	$(TOOLDIR)/pics    -S -r0.001 -t traj2.ra ksp.ra o.ra reco1.ra			;\
	$(TOOLDIR)/pics -g -S -r0.001 -t traj2.ra ksp.ra o.ra reco2.ra			;\
	$(TOOLDIR)/nrmse -t 0.001 reco1.ra reco2.ra					;\
	rm *.ra ; cd .. ; rmdir $(TESTS_TMP)
	touch $@



tests/test-pics-gpu-weights: phantom pics scale ones nrmse $(TESTS_OUT)/shepplogan.ra $(TESTS_OUT)/shepplogan_coil.ra
	set -e; mkdir $(TESTS_TMP) ; cd $(TESTS_TMP)					;\
	$(TOOLDIR)/phantom -S8 coils.ra							;\
	$(TOOLDIR)/ones 2 128 128 weights.ra						;\
	$(TOOLDIR)/scale 0.1 weights.ra weights2.ra					;\
	$(TOOLDIR)/pics    -S -r0.001 -p weights2.ra $(TESTS_OUT)/shepplogan_coil.ra coils.ra reco1.ra	;\
	$(TOOLDIR)/pics -g -S -r0.001 -p weights2.ra $(TESTS_OUT)/shepplogan_coil.ra coils.ra reco2.ra	;\
	$(TOOLDIR)/nrmse -t 0.000001 reco2.ra reco1.ra				 	;\
	rm *.ra ; cd .. ; rmdir $(TESTS_TMP)
	touch $@



tests/test-pics-gpu-noncart-weights: traj scale ones phantom pics nrmse
	set -e; mkdir $(TESTS_TMP) ; cd $(TESTS_TMP)					;\
	$(TOOLDIR)/traj -r -x256 -y32 traj.ra						;\
	$(TOOLDIR)/scale 0.5 traj.ra traj2.ra						;\
	$(TOOLDIR)/phantom -s8 -t traj2.ra ksp.ra					;\
	$(TOOLDIR)/phantom -S8 coils.ra							;\
	$(TOOLDIR)/ones 4 1 256 32 1 weights.ra						;\
	$(TOOLDIR)/scale 0.1 weights.ra weights2.ra					;\
	$(TOOLDIR)/pics    -S -r0.001 -p weights2.ra -t traj2.ra ksp.ra coils.ra reco1.ra ;\
	$(TOOLDIR)/pics -g -S -r0.001 -p weights2.ra -t traj2.ra ksp.ra coils.ra reco2.ra ;\
	$(TOOLDIR)/nrmse -t 0.005 reco1.ra reco2.ra					;\
	rm *.ra ; cd .. ; rmdir $(TESTS_TMP)
	touch $@




TESTS_GPU += tests/test-pics-gpu tests/test-pics-gpu-noncart
TESTS_GPU += tests/test-pics-gpu-weights tests/test-pics-gpu-noncart-weights

