importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var macroInput = DataUtil.createMacrosInput(true);
var pv = PVUtil.getString(pvArray[0]);

macroInput.put("Channel2Macro", pv);
widgetController.setPropertyValue("macros", macroInput);

