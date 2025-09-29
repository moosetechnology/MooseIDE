Class {
	#name : #MiSystemComplexitySettingsConfiguration,
	#superclass : #MiAbstractSettingsConfiguration,
	#instVars : [
		'startColor',
		'endColor',
		'heightMetric',
		'widthMetric',
		'colorMetric',
		'availableMetrics',
		'displayedName',
		'heightMetricThreshold',
		'widthMetricThreshold',
		'colorMetricThreshold'
	],
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> availableMetrics [

	^ availableMetrics
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> availableMetrics: aCollection [

	availableMetrics := aCollection
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> colorMetric [

	^ colorMetric
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> colorMetric: aFM3Property [

	colorMetric := aFM3Property
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> colorMetricThreshold [

	^ colorMetricThreshold
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> colorMetricThreshold: anObject [

	colorMetricThreshold := anObject
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> displayedName [

	^ displayedName
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> displayedName: aSymbol [

	displayedName := aSymbol
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> endColor [

	^ endColor
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> endColor: anObject [

	endColor := anObject
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> heightMetric [

	^ heightMetric
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> heightMetric: aFM3Property [

	heightMetric := aFM3Property
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> heightMetricThreshold [

	^ heightMetricThreshold
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> heightMetricThreshold: anObject [

	heightMetricThreshold := anObject
]

{ #category : #ui }
MiSystemComplexitySettingsConfiguration >> settingsPresenters [

	^ super settingsPresenters
		  add: ((MiDroplistSettingPresenter on: self)
				   label: 'Height metric:';
				   help: 'Metric used to determine the height of the boxes';
				   items: availableMetrics;
				   selectItem: heightMetric;
				   display: [ :symbol | symbol asWords ];
				   whenSelectedDo: [ :property | self heightMetric: property ]);
		  add: ((MiNumberSettingPresenter on: self)
				   label: 'Heigh similarity threshold';
				   help:
					   'If the difference for the height metric between entities are below this threshold, normalize the height to make them look similar';
				   number: heightMetricThreshold;
				   whenNumberChangedDo: [ :nb | self heightMetricThreshold: nb ];
				   yourself);
		  add: ((MiDroplistSettingPresenter on: self)
				   label: 'Width metric:';
				   help: 'Metric used to determine the width of the boxes';
				   items: availableMetrics;
				   selectItem: widthMetric;
				   display: [ :symbol | symbol asWords ];
				   whenSelectedDo: [ :property | self widthMetric: property ]);
		  add: ((MiNumberSettingPresenter on: self)
				   label: 'Width similarity threshold';
				   help:
					   'If the difference for the width metric between entities are below this threshold, normalize the width to make them look similar';
				   number: widthMetricThreshold;
				   whenNumberChangedDo: [ :nb | self widthMetricThreshold: nb ];
				   yourself);
		  add: ((MiDroplistSettingPresenter on: self)
				   label: 'Color metric:';
				   help: 'Metric used to determine the color of the boxes';
				   items: availableMetrics;
				   selectItem: colorMetric;
				   display: [ :symbol | symbol asWords ];
				   whenSelectedDo: [ :property | self colorMetric: property ]);
		  add: ((MiNumberSettingPresenter on: self)
				   label: 'Color similarity threshold';
				   help:
					   'If the difference for the color metric between entities are below this threshold, normalize the color to make them look similar';
				   number: colorMetricThreshold;
				   whenNumberChangedDo: [ :nb | self colorMetricThreshold: nb ];
				   yourself);
		  add: (MiColorGradientSelectionPresenter on: self);
		  add: (MiDisplayedNameSettingPresenter on: self);
		  yourself
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> startColor [

	^ startColor
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> startColor: anObject [

	startColor := anObject
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> widthMetric [

	^ widthMetric
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> widthMetric: aFM3Property [

	widthMetric := aFM3Property
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> widthMetricThreshold [

	^ widthMetricThreshold
]

{ #category : #accessing }
MiSystemComplexitySettingsConfiguration >> widthMetricThreshold: anObject [

	widthMetricThreshold := anObject
]
