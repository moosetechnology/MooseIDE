Class {
	#name : #MiSystemComplexityModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'settings',
		'entities'
	],
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #initialization }
MiSystemComplexityModel >> availableMetrics [

	entities ifEmpty: [ ^ OrderedCollection new ].
	^ (((entities allEntityTypes collect: [ :entity | 
		     entity famePropertiesOfType: FM3Number ]) fold: [ 
		    :availableProperties 
		    :entityProperties | availableProperties & entityProperties ]) 
		   collect: #implementingSelector) asOrderedCollection sort: [ :a :b | 
		  a < b ]
]

{ #category : #initialization }
MiSystemComplexityModel >> browser: aBrowser [

	browser := aBrowser.
	
	self initializeSettings
]

{ #category : #accessing }
MiSystemComplexityModel >> colorMetric [

	^ settings getItemValue: #colorMetric
]

{ #category : #initialization }
MiSystemComplexityModel >> colorRangeEnd [

	^ settings getItemValue: #colorRangeEnd
]

{ #category : #initialization }
MiSystemComplexityModel >> colorRangeStart [

	^ settings getItemValue: #colorRangeStart
]

{ #category : #initialization }
MiSystemComplexityModel >> defaultColorMetric [

	^ nil
]

{ #category : #initialization }
MiSystemComplexityModel >> defaultHeightMetric [

	^ nil
]

{ #category : #initialization }
MiSystemComplexityModel >> defaultWidthMetric [

	^ nil
]

{ #category : #accessing }
MiSystemComplexityModel >> entities [

	^ entities
]

{ #category : #accessing }
MiSystemComplexityModel >> entities: aMooseGroup [

	aMooseGroup ifEmpty: [ ^ self ].
	entities := aMooseGroup.
	self updateSettings.
	browser buildVisualization
]

{ #category : #accessing }
MiSystemComplexityModel >> heightMetric [

	^ settings getItemValue: #heightMetric
]

{ #category : #initialization }
MiSystemComplexityModel >> initialize [

	super initialize.
	entities := MooseGroup new.
]

{ #category : #initialization }
MiSystemComplexityModel >> initializeSettings [

	settings := super initializeSettings
		            addItem: self itemHeightMetric named: #heightMetric;
		            addItem: self itemWidthMetric named: #widthMetric;
		            addItem: self itemColorMetric named: #colorMetric;
		            addItem: self itemColorRangeStart
		            named: #colorRangeStart;
		            addItem: self itemColorRangeEnd named: #colorRangeEnd;
		            addItem: self itemNameToDisplay named: #nameToDisplay;
		            yourself
]

{ #category : #initialization }
MiSystemComplexityModel >> itemColorMetric [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: self availableMetrics;
		  setValue: self defaultColorMetric;
		  label: 'Color metric:';
		  help: 'The metric leading the normalization of boxes color.';
		  yourself
]

{ #category : #initialization }
MiSystemComplexityModel >> itemColorRangeEnd [

	^ MiAbstractSettingItem colorSetting
		  setValue: Color black;
		  label: 'Color range end:';
		  help:
			  'End color for scaling color metric.';
		  yourself
]

{ #category : #initialization }
MiSystemComplexityModel >> itemColorRangeStart [

	^ MiAbstractSettingItem colorSetting
		  setValue: Color white;
		  label: 'Color range start:';
		  help:
			  'Start color for scaling color metric.';
		  yourself
]

{ #category : #initialization }
MiSystemComplexityModel >> itemHeightMetric [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: self availableMetrics;
		  setValue: self defaultHeightMetric;
		  label: 'Height metric:';
		  help: 'The metric leading the normalization of boxes height.';
		  yourself
]

{ #category : #initialization }
MiSystemComplexityModel >> itemNameToDisplay [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: {#mooseName. #name};
		  setValue: #name;
		  label: 'Name to display:';
		  help: 'Entity names type to display.';
		  yourself
]

{ #category : #initialization }
MiSystemComplexityModel >> itemWidthMetric [

	^ MiAbstractSettingItem droplistSetting
		  possibleValues: self availableMetrics;
		  setValue: self defaultWidthMetric;
		  label: 'Width metric:';
		  help: 'The metric leading the normalization of boxes width.';
		  yourself
]

{ #category : #initialization }
MiSystemComplexityModel >> nameToDisplay [

	^ settings getItemValue: #nameToDisplay
]

{ #category : #accessing }
MiSystemComplexityModel >> settings [

	^ settings
]

{ #category : #initialization }
MiSystemComplexityModel >> settingsChanged: aBoolean [

	aBoolean ifTrue: [ browser buildVisualization ]
]

{ #category : #accessing }
MiSystemComplexityModel >> updateSettings [

	(settings itemNamed: #heightMetric)
		possibleValues: self availableMetrics;
		setValue: #numberOfMethods.
	(settings itemNamed: #widthMetric)
		possibleValues: self availableMetrics;
		setValue: #numberOfAttributes.
	(settings itemNamed: #colorMetric)
		possibleValues: self availableMetrics;
		setValue: #numberOfLinesOfCode
]

{ #category : #accessing }
MiSystemComplexityModel >> widthMetric [

	^ settings getItemValue: #widthMetric
]
