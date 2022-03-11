Extension { #name : #MiCoUsageMapSettings }

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoUsageMapSettings class >> browsingBlockSettings: aBuilder [
	<systemsettings>
	(aBuilder group: #ShowBlockSettings)
		target: self;
		parent: #CoUsageMap;
		order: 101;
		label: 'Blocks settings';
		description: 'Recives 2 outer nodes, returns if it should swap nodes';
		dialog: [ PluggableButtonMorph
			on: self
			getState: nil
			action: #openBlocksSettings
			label: #buttonSettingLabel ]
		

]

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoUsageMapSettings class >> browsingSettingInnerSize: aBuilder [
	<systemsettings>
	(aBuilder miRange: #innerBoxSize)
		parent: #CoUsageMap;
		target: self;
		order: 1;
		label: 'Inner box size';
		description: 'Will change the size of the inner box for co usage map visualization';
		default: self defaultInnerBoxSize;
		range: (2 to: 50)

]

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoUsageMapSettings class >> browsingSettingThreshold: aBuilder [
	<systemsettings>
	(aBuilder miRange: #threshold75PercentGroup)
		parent: #CoUsageMap;
		target: self;
		order: 0;
		label: 'Threshold percent per group';
		description: 'This threshold is used by automatic color methods in the CoUsageMapBrowser.
When the container has several attributes of different colors, the color is chosen from the group that exceeds the threshold in relation to the size of the attributes.';
		default: self defaultThreshold75;
		range: (10 to: 100)

]

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoUsageMapSettings class >> buttonSettingLabel [
	^ 'Blocks Settings'
		

]

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
MiCoUsageMapSettings class >> openBlocksSettings [

	MiCoUsageMapSettingsPresenter new open
]
