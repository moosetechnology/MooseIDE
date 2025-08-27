Class {
	#name : 'MiSystemComplexityModel',
	#superclass : 'MiAbstractModel',
	#traits : 'MiTSpecModelWithSettings',
	#classTraits : 'MiTSpecModelWithSettings classTrait',
	#instVars : [
		'settings',
		'entities',
		'availableMetrics',
		'startColor',
		'endColor',
		'heightMetric',
		'widthMetric',
		'colorMetric'
	],
	#category : 'MooseIDE-Visualization-System Complexity',
	#package : 'MooseIDE-Visualization',
	#tag : 'System Complexity'
}

{ #category : 'as yet unclassified' }
MiSystemComplexityModel class >> defaultAvailableMetrics [

	^ OrderedCollection withAll: {
			  self defaultHeightMetric.
			  self defaultWidthMetric.
			  self defaultColorMetric }
]

{ #category : 'initialization' }
MiSystemComplexityModel class >> defaultColorMetric [

	^ #numberOfLinesOfCode
]

{ #category : 'initialization' }
MiSystemComplexityModel class >> defaultEndColor [

	^ Color black
]

{ #category : 'initialization' }
MiSystemComplexityModel class >> defaultHeightMetric [

	^ #numberOfMethods
]

{ #category : 'initialization' }
MiSystemComplexityModel class >> defaultStartColor [

	^ Color white
]

{ #category : 'initialization' }
MiSystemComplexityModel class >> defaultWidthMetric [

	^ #numberOfAttributes
]

{ #category : 'accessing' }
MiSystemComplexityModel class >> newMementoForDefaultValues [

	^ MiSystemComplexitySettingsMemento new
		  heightMetric: self defaultHeightMetric;
		  widthMetric: self defaultHeightMetric;
		  colorMetric: self defaultColorMetric;
		  startColor: self defaultStartColor;
		  endColor: self defaultEndColor;
		  yourself
]

{ #category : 'initialization' }
MiSystemComplexityModel >> availableMetrics [

	entities ifEmpty: [ ^ self class defaultAvailableMetrics ].

	^ self availableMetricsForEntities
]

{ #category : 'accessing' }
MiSystemComplexityModel >> availableMetricsForEntities [
	"entities are 
		- MooseObjects (See MiSystemComplexityBrowser>>#canFollowEntity:) 
		- returning true to #isClass (See MiSystemComplexityBrowser>>#followEntity:) 
	i.e. instances of FamixXYZClass"

	^ ((entities anyOne famePropertiesOfType: FM3Number) collect:
		   #implementingSelector) sorted: #yourself ascending
]

{ #category : 'accessing' }
MiSystemComplexityModel >> colorMetric [

	^ colorMetric
]

{ #category : 'initialization' }
MiSystemComplexityModel >> endColor [

	^ endColor
]

{ #category : 'accessing' }
MiSystemComplexityModel >> entities [

	^ entities
]

{ #category : 'accessing' }
MiSystemComplexityModel >> entities: aMooseGroup [

	entities := aMooseGroup
]

{ #category : 'accessing' }
MiSystemComplexityModel >> heightMetric [

	^ heightMetric
]

{ #category : 'initialization' }
MiSystemComplexityModel >> initialize [

	super initialize.
	entities := MooseGroup new
]

{ #category : 'initialization' }
MiSystemComplexityModel >> initializeSettings [

	startColor := self class defaultStartColor.
	endColor := self class defaultEndColor.
	heightMetric := self class defaultHeightMetric.
	widthMetric := self class defaultWidthMetric.
	colorMetric := self class defaultColorMetric.

	settings := super initializeSettings
		            addItem: self itemNameToDisplay named: #nameToDisplay;
		            yourself
]

{ #category : 'initialization' }
MiSystemComplexityModel >> itemNameToDisplay [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: {#mooseName. #name};
		  setValue: #name;
		  label: 'Name to display:';
		  help: 'Entity names type to display.';
		  yourself
]

{ #category : 'accessing' }
MiSystemComplexityModel >> miSelectedItem [

	^ entities
]

{ #category : 'initialization' }
MiSystemComplexityModel >> nameToDisplay [

	^ settings getItemValue: #nameToDisplay
]

{ #category : 'instance creation' }
MiSystemComplexityModel >> newMemento [

	^ MiSystemComplexitySettingsMemento new
		  availableMetrics: self availableMetrics;
		  heightMetric: heightMetric;
		  widthMetric: widthMetric;
		  colorMetric: colorMetric;
		  startColor: startColor;
		  endColor: endColor
]

{ #category : 'settings management' }
MiSystemComplexityModel >> newMementoForDefaultValues [

	^ self class newMementoForDefaultValues
		  availableMetrics: self availableMetrics;
		  yourself
]

{ #category : 'accessing' }
MiSystemComplexityModel >> settings [

	^ settings
]

{ #category : 'accessing' }
MiSystemComplexityModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser runVisualization ]
]

{ #category : 'settings management' }
MiSystemComplexityModel >> settingsPresenterExtent [
	"Override to set a custom size"

	^ 400 @ 300
]

{ #category : 'initialization' }
MiSystemComplexityModel >> startColor [

	^ startColor
]

{ #category : 'settings management' }
MiSystemComplexityModel >> updateFromMemento: aMemento [

	heightMetric := aMemento heightMetric.
	widthMetric := aMemento widthMetric.
	colorMetric := aMemento colorMetric.
	startColor := aMemento startColor.
	endColor := aMemento endColor.

	browser runVisualization
]

{ #category : 'accessing' }
MiSystemComplexityModel >> widthMetric [

	^ widthMetric
]
