"
I am a singleton, I store global values for settings used by CoUsageMapBuilder
"
Class {
	#name : #MiCoUsageMapSettings,
	#superclass : #Object,
	#classInstVars : [
		'threshold75',
		'childrenBlockText',
		'outerBoxSortBlockText',
		'innerBoxSortBlockText',
		'innerBoxRange',
		'innerBoxScaleType',
		'innerBoxHeight'
	],
	#category : #'MooseIDE-CoUsageMap-Settings'
}

{ #category : #private }
MiCoUsageMapSettings class >> browserDo: aBlock [
	Smalltalk globals 
		at: #MiCoUsageMapBuilder
		ifPresent: [ :cls | cls withAllSubclassesDo: [ :each | each allInstancesDo: aBlock ]  ]
		ifAbsent: [ "nothing" ]
]

{ #category : #settings }
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingInnerBoxRange: aBuilder [
	<systemsettings>
	
	(aBuilder miDualRange: #innerBoxRange)
		parent: #CoUsageMap;
		target: self;
		order: 4;
		label: 'Range for inner boxes';
		description: 'Use this to change the minimun and maximun size of the inner boxes';
		default: self defaultInnerBoxRange;
		range: (5 to: 100)

]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingInnerScale: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #innerBoxScaleType)
		parent: #CoUsageMap;
		domainValues: #(linear symlog);
		target: self;
		order: 3;
		label: 'Inner box width scale';
		description: 'Choose between different types of scales';
		default: self defaultInnerBoxScaleType
]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingInnerSize: aBuilder [
	<systemsettings>
	(aBuilder miRange: #innerBoxHeight)
		parent: #CoUsageMap;
		target: self;
		order: 1;
		label: 'Inner box height';
		description: 'Will change the height of the inner box for co usage map visualization';
		default: self defaultInnerBoxHeight;
		range: (2 to: 50)

]

{ #category : #settings }
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettings01On: aBuilder [
	<systemsettings>
	(aBuilder group: #moose)
		label: 'Moose';
		description: 'All settings concerned with moose browsers'
]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettings02On: aBuilder [
	<systemsettings>
	(aBuilder group: #CoUsageMap)
		parent: #moose;
		label: 'Co Usage Map';
		description: 'Alls settings concerned with co usage map browser'
]

{ #category : #accessing }
MiCoUsageMapSettings class >> buttonSettingLabel [
	^ 'Blocks Settings'
		

]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> childrenBlockCompiled [
	^ self compiledBlock: self childrenBlockText onError: self defaultChildrenBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> childrenBlockText [
	^ childrenBlockText ifNil: [ self defaultChildrenBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> childrenBlockText: aString [
	childrenBlockText := aString.
	self browserDo: [ :b | b updateChildren ].
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> compiledBlock: aString onError: defaultString [
	| compiler |
	compiler := Smalltalk compiler.
	^ [ compiler evaluate: aString ]
	on: Error
	do: [ :ex | compiler evaluate: defaultString ]
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultChildrenBlockText [
	^ '[ :entity |
"this code is for entity method, but you can change it"
"you should return all the inner entities even with duplicates"

entity accesses 
	select: [ :slotLink | slotLink variable isAttribute ]
	thenCollect: [ :slotLink | slotLink variable ]
 ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxHeight [
	^ 10
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxRange [
	^ #(5 100)
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxScaleType [
	^ #linear
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultInnerBoxSortBlockText [
	^ '[:entityA :entityB | entityA name < entityB name ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultOuterBoxSortBlockText [
	^ '[:containerA :containerB |
"containers are MiCoMethod instances"
| sizeA sizeB |
sizeA := containerA children size.
sizeB := containerB children size.
sizeA = sizeB
	ifTrue: [ containerA name < containerB name ]
	ifFalse: [ sizeA > sizeB ] ]'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultThreshold75 [
	^ 75
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxHeight [
	^ innerBoxHeight ifNil: [ self defaultInnerBoxHeight ].
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxHeight: aNumber [
	innerBoxHeight := aNumber.
	self updateBrowserInnerBoxSize
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxRange [
	^ innerBoxRange ifNil: [ self defaultInnerBoxRange ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxRange: anInterval [
	innerBoxRange := anInterval.
	self updateBrowserInnerBoxSize
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxScaleType [
	^ innerBoxScaleType ifNil: [ self defaultInnerBoxScaleType ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxScaleType: aString [
	innerBoxScaleType := aString.
	self updateBrowserInnerBoxSize
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> innerBoxSortBlockCompiled [
	^ self compiledBlock: self innerBoxSortBlockText onError: self defaultInnerBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlockText [
	^ innerBoxSortBlockText ifNil: [ self defaultInnerBoxSortBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSortBlockText: aString [
	innerBoxSortBlockText := aString.
	self browserDo: [ :b | b updateShapeLayout ]
]

{ #category : #opening }
MiCoUsageMapSettings class >> openBlocksSettings [

	MiCoUsageMapSettingsPresenter new open
]

{ #category : #'accessing - computed' }
MiCoUsageMapSettings class >> outerBoxSortBlockCompiled [
	^ self compiledBlock: self outerBoxSortBlockText onError: self defaultOuterBoxSortBlockText
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlockText [
	^ outerBoxSortBlockText ifNil: [ self defaultOuterBoxSortBlockText ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> outerBoxSortBlockText: aString [
	outerBoxSortBlockText := aString.
	self browserDo: [ :b | b updateShapeLayout ]
]

{ #category : #'class initialization' }
MiCoUsageMapSettings class >> reset [
	<script>
	innerBoxHeight := threshold75 := childrenBlockText := outerBoxSortBlockText := 
	innerBoxSortBlockText := innerBoxRange := nil
]

{ #category : #'class initialization' }
MiCoUsageMapSettings class >> resetText [
	<script>
	childrenBlockText := outerBoxSortBlockText := innerBoxSortBlockText := nil
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup [
	^ threshold75 ifNil: [ self defaultThreshold75 ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> threshold75PercentGroup: aNumber [
	threshold75 := aNumber.
	self browserDo: [ :b | b threshold75: threshold75 ]
]

{ #category : #private }
MiCoUsageMapSettings class >> updateBrowserInnerBoxSize [
	self browserDo: [ :browser | browser updateInnerBoxSize ]
]
