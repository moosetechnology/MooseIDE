Extension { #name : #MiCoUsageMapSettings }

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoUsageMapSettings class >> browsingSettingsInnerSizeOn: aBuilder [
	<systemsettings>
	(aBuilder miRange: #innerBoxSize)
		parent: #CoUsageMap;
		target: self;
		label: 'Inner box size';
		description: 'Will change the size of the inner box for co usage map visualization';
		default: self defaultInnerBoxSize;
		range: (2 to: 50)

]

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoUsageMapSettings class >> browsingSettingsThresholdOn: aBuilder [
	<systemsettings>
	(aBuilder miRange: #threshold75PercentGroup)
		parent: #CoUsageMap;
		target: self;
		label: 'Threshold 75 percent per group';
		description: 'This threshold is used by automatic color methods in the CoUsageMapBrowser.
When the container has several attributes of different colors, the color is chosen from the group that exceeds the threshold in relation to the size of the attributes.';
		default: self defaultThreshold75;
		range: (10 to: 100)

]
