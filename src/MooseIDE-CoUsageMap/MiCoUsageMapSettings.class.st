"
I am a singleton, I store global values for settings used by CoUsageMapBuilder
"
Class {
	#name : #MiCoUsageMapSettings,
	#superclass : #Object,
	#classInstVars : [
		'innerBoxSize',
		'threshold75',
		'childrenBlockText',
		'outerBoxSortBlockText',
		'innerBoxSortBlockText',
		'tagNeedWorkColor',
		'tagNeedWorkName'
	],
	#category : #'MooseIDE-CoUsageMap-Model'
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

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingTagNeedWorkColor: aBuilder [
	<systemsettings>
	(aBuilder setting: #tagNeedWorkColor)
		parent: #CoUsageMap;
		target: self;
		order: 11;
		label: 'Conflict tag color';
		description: 'It will be used as default color for conflicts in co-usage-map browser';
		default: self defaultTagNeedWorkName
]

{ #category : #settings }
MiCoUsageMapSettings class >> browsingSettingTagNeedWorkName: aBuilder [
	<systemsettings>
	(aBuilder setting: #tagNeedWorkName)
		parent: #CoUsageMap;
		target: self;
		order: 10;
		label: 'Conflict tag name';
		description: 'It will be used as default name for conflicts in co-usage-map browser';
		ghostHelp: 'tag name';
		default: self defaultTagNeedWorkName
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
MiCoUsageMapSettings class >> defaultInnerBoxSize [
	^ 5
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
MiCoUsageMapSettings class >> defaultTagNeedWorkColor [
	^ MDLColor red
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultTagNeedWorkName [
	^ 'Need work'
]

{ #category : #'accessing - defaults' }
MiCoUsageMapSettings class >> defaultThreshold75 [
	^ 75
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSize [
	^ innerBoxSize ifNil: [ self defaultInnerBoxSize ].
]

{ #category : #accessing }
MiCoUsageMapSettings class >> innerBoxSize: aNumber [
	innerBoxSize := aNumber.
	self browserDo: [ :b | b innerBoxSize: aNumber ]
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

{ #category : #initialization }
MiCoUsageMapSettings class >> reset [
	<script>
	innerBoxSize := threshold75 := childrenBlockText := outerBoxSortBlockText := innerBoxSortBlockText := nil
]

{ #category : #initialization }
MiCoUsageMapSettings class >> resetText [
	<script>
	childrenBlockText := outerBoxSortBlockText := innerBoxSortBlockText := nil
]

{ #category : #accessing }
MiCoUsageMapSettings class >> tagNeedWorkColor [
	^ tagNeedWorkColor ifNil: [ self defaultTagNeedWorkColor ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> tagNeedWorkColor: aColor [
	tagNeedWorkColor := MDLColor r: aColor red g: aColor green b: aColor blue alpha: aColor alpha
]

{ #category : #accessing }
MiCoUsageMapSettings class >> tagNeedWorkName [
	^ tagNeedWorkName ifNil: [ self defaultTagNeedWorkName ]
]

{ #category : #accessing }
MiCoUsageMapSettings class >> tagNeedWorkName: aString [
	(aString isNil or: [ aString trimmed isEmpty ]) ifTrue: [ ^ self ].
	tagNeedWorkName := aString.
	"self browserDo: [ :browser | 
		browser conflictTag ifNotNil: [ :tag | tag name: aString ].
		browser updateLegend.
		]"
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
