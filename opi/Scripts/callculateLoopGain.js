importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var cavMag = PVUtil.getDouble(pvArray[0]);
var spMag  = PVUtil.getDouble(pvArray[1]);
var vmLimit  = PVUtil.getDouble(pvArray[2]);
var vmEnabled = PVUtil.getDouble(pvArray[3]);

var out = spMag;
if (vmLimit <= spMag && vmEnabled==1.0) {
	out = vmLimit;
}
var gain = cavMag/out;

pvArray[4].setValue(out);
pvArray[5].setValue(gain);