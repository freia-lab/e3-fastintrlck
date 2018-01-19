importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var cavAng = PVUtil.getDouble(pvArray[0]);
var refAng = PVUtil.getDouble(pvArray[1]);
var iqAng  = PVUtil.getDouble(pvArray[2]);
var iqAngEn = PVUtil.getDouble(pvArray[3]);
var fixedSPAng  = PVUtil.getDouble(pvArray[4]);

var compensatedAng;
var delay;

if (iqAngEn == 0.0) {
	iqAng = 0.0;
}
compensatedAng = cavAng - refAng;
compensatedAng += (compensatedAng > Math.PI) ? (-2*Math.PI) : ( (compensatedAng < -Math.PI) ? 2*Math.PI : 0);
compensatedAng += iqAng;
pvArray[5].setValue(compensatedAng);

delay = fixedSPAng - compensatedAng;
pvArray[6].setValue(delay);

//ConsoleUtil.writeInfo(compensatedAng);
//ConsoleUtil.writeInfo(PVUtil.getDouble(pvArray[5]));
//ConsoleUtil.writeInfo(delay);
//ConsoleUtil.writeInfo(PVUtil.getDouble(pvArray[6]));
//ConsoleUtil.writeInfo("--------");
