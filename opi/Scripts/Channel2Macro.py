from org.csstudio.display.builder.runtime.script import PVUtil

channel = PVUtil.getString(pvs[0])

# Adding the macros on the widget that will consume this script
widget.getPropertyValue("macros").add("Channel2Macro", channel)

widget.setPropertyValue("file", "")
widget.setPropertyValue("file", "./PMD-graph.bob")
