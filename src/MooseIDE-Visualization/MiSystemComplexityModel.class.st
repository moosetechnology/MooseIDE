Class {
	#name : #MiSystemComplexityModel,
	#superclass : #MiAbstractModel,
	#instVars : [
		'entities',
		'startColor',
		'endColor',
		'heightMetric',
		'widthMetric',
		'colorMetric',
		'displayedName',
		'colorMetricThreshold',
		'widthMetricThreshold',
		'heightMetricThreshold'
	],
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #default }
MiSystemComplexityModel class >> defaultAvailableMetrics [

	^ OrderedCollection withAll: {
			  self defaultHeightMetric.
			  self defaultWidthMetric.
			  self defaultColorMetric }
]

{ #category : #default }
MiSystemComplexityModel class >> defaultColorMetric [

	^ #numberOfLinesOfCode
]

{ #category : #default }
MiSystemComplexityModel class >> defaultColorMetricThreshold [

	^ 100
]

{ #category : #'settings management' }
MiSystemComplexityModel class >> defaultConfiguration [

	^ MiSystemComplexitySettingsConfiguration new
		  heightMetric: self defaultHeightMetric;
		  heightMetricThreshold: self defaultHeightMetricThreshold;
		  widthMetric: self defaultWidthMetric;
		  widthMetricThreshold: self defaultWidthMetricThreshold;
		  colorMetric: self defaultColorMetric;
		  colorMetricThreshold: self defaultColorMetricThreshold;
		  startColor: self defaultStartColor;
		  endColor: self defaultEndColor;
		  displayedName: self defaultDisplayedName;
		  yourself
]

{ #category : #default }
MiSystemComplexityModel class >> defaultDisplayedName [

	^ #name
]

{ #category : #default }
MiSystemComplexityModel class >> defaultEndColor [

	^ Color black
]

{ #category : #default }
MiSystemComplexityModel class >> defaultHeightMetric [

	^ #numberOfMethods
]

{ #category : #default }
MiSystemComplexityModel class >> defaultHeightMetricThreshold [

	^ 10
]

{ #category : #default }
MiSystemComplexityModel class >> defaultStartColor [

	^ Color white
]

{ #category : #default }
MiSystemComplexityModel class >> defaultWidthMetric [

	^ #numberOfAttributes
]

{ #category : #default }
MiSystemComplexityModel class >> defaultWidthMetricThreshold [

	^ 10
]

{ #category : #accessing }
MiSystemComplexityModel >> availableMetrics [

	entities ifEmpty: [ ^ self class defaultAvailableMetrics ].

	^ self availableMetricsForEntities
]

{ #category : #accessing }
MiSystemComplexityModel >> availableMetricsForEntities [
	"entities are 
		- MooseObjects (See MiSystemComplexityBrowser>>#canFollowEntity:) 
		- returning true to #isClass (See MiSystemComplexityBrowser>>#followEntity:) 
	i.e. instances of FamixXYZClass.
	We still have to take an entity to get the correct metamodel for the metadescription"

	^ ((entities anyOne famePropertiesOfType: FM3Number) collect:
		   #implementingSelector) sorted: #yourself ascending
]

{ #category : #accessing }
MiSystemComplexityModel >> colorMetric [

	^ colorMetric
]

{ #category : #accessing }
MiSystemComplexityModel >> colorMetricThreshold [

	^ colorMetricThreshold
]

{ #category : #'settings management' }
MiSystemComplexityModel >> currentConfiguration [

	^ MiSystemComplexitySettingsConfiguration new
		  availableMetrics: self availableMetrics;
		  heightMetric: heightMetric;
		  heightMetricThreshold: heightMetricThreshold;
		  widthMetric: widthMetric;
		  widthMetricThreshold: widthMetricThreshold;
		  colorMetric: colorMetric;
		  colorMetricThreshold: colorMetricThreshold;
		  startColor: startColor;
		  endColor: endColor;
		  displayedName: displayedName
]

{ #category : #'settings management' }
MiSystemComplexityModel >> defaultConfiguration [

	^ self class defaultConfiguration
		  availableMetrics: self availableMetrics;
		  yourself
]

{ #category : #accessing }
MiSystemComplexityModel >> displayedName [

	^ displayedName
]

{ #category : #accessing }
MiSystemComplexityModel >> endColor [

	^ endColor
]

{ #category : #accessing }
MiSystemComplexityModel >> entities [

	^ entities
]

{ #category : #accessing }
MiSystemComplexityModel >> entities: aMooseGroup [

	entities := aMooseGroup
]

{ #category : #testing }
MiSystemComplexityModel >> hasSettings [

	^ true
]

{ #category : #accessing }
MiSystemComplexityModel >> heightMetric [

	^ heightMetric
]

{ #category : #accessing }
MiSystemComplexityModel >> heightMetricThreshold [

	^ heightMetricThreshold
]

{ #category : #initialization }
MiSystemComplexityModel >> initialize [

	super initialize.
	entities := MooseGroup new
]

{ #category : #initialization }
MiSystemComplexityModel >> initializeSettings [

	startColor := self class defaultStartColor.
	endColor := self class defaultEndColor.
	heightMetric := self class defaultHeightMetric.
	heightMetricThreshold := self class defaultHeightMetricThreshold.
	widthMetric := self class defaultWidthMetric.
	widthMetricThreshold := self class defaultWidthMetricThreshold.
	colorMetric := self class defaultColorMetric.
	colorMetricThreshold := self class defaultColorMetricThreshold.
	displayedName := self class defaultDisplayedName
]

{ #category : #accessing }
MiSystemComplexityModel >> miSelectedItem [

	^ entities
]

{ #category : #'settings management' }
MiSystemComplexityModel >> settingsPresenterExtent [

	^ 380 @ 400
]

{ #category : #accessing }
MiSystemComplexityModel >> startColor [

	^ startColor
]

{ #category : #'settings management' }
MiSystemComplexityModel >> updateFromConfiguration: aConfiguration [

	heightMetric := aConfiguration heightMetric.
	heightMetricThreshold := aConfiguration heightMetricThreshold.
	widthMetric := aConfiguration widthMetric.
	widthMetricThreshold := aConfiguration widthMetricThreshold.
	colorMetric := aConfiguration colorMetric.
	colorMetricThreshold := aConfiguration colorMetricThreshold.
	startColor := aConfiguration startColor.
	endColor := aConfiguration endColor.
	displayedName := aConfiguration displayedName.

	browser runVisualization
]

{ #category : #accessing }
MiSystemComplexityModel >> widthMetric [

	^ widthMetric
]

{ #category : #accessing }
MiSystemComplexityModel >> widthMetricThreshold [

	^ widthMetricThreshold
]
