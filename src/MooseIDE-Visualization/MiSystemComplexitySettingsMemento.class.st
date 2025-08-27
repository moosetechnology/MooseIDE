Class {
	#name : 'MiSystemComplexitySettingsMemento',
	#superclass : 'MiMemento',
	#instVars : [
		'startColor',
		'endColor',
		'heightMetric',
		'widthMetric',
		'colorMetric',
		'availableMetrics'
	],
	#category : 'MooseIDE-Visualization-System Complexity',
	#package : 'MooseIDE-Visualization',
	#tag : 'System Complexity'
}

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> availableMetrics: aCollection [

	availableMetrics := aCollection
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> colorMetric [

	^ colorMetric
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> colorMetric: aFM3Property [

	colorMetric := aFM3Property
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> endColor [

	^ endColor
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> endColor: anObject [

	endColor := anObject
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> heightMetric [

	^ heightMetric
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> heightMetric: aFM3Property [

	heightMetric := aFM3Property
]

{ #category : 'ui' }
MiSystemComplexitySettingsMemento >> settingsPresenters [

	^ super settingsPresenters
		  add: ((MiDroplistSettingPresenter on: self)
				   label: 'Height metric:';
				   help: 'Metric used to determine the height of the boxes';
				   items: availableMetrics;
				   selectItem: heightMetric;
				   display: [ :symbol | symbol asWords ];
				   whenSelectedDo: [ :property | self heightMetric: property ]);
		  add: ((MiDroplistSettingPresenter on: self)
				   label: 'Width metric:';
				   help: 'Metric used to determine the width of the boxes';
				   items: availableMetrics;
				   selectItem: widthMetric;
				   display: [ :symbol | symbol asWords ];
				   whenSelectedDo: [ :property | self widthMetric: property ]);
		  add: ((MiDroplistSettingPresenter on: self)
				   label: 'Color metric:';
				   help: 'Metric used to determine the color of the boxes';
				   items: availableMetrics;
				   selectItem: colorMetric;
				   display: [ :symbol | symbol asWords ];
				   whenSelectedDo: [ :property | self colorMetric: property ]);
		  add: (MiColorGradientSelectionPresenter on: self);
		  yourself
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> startColor [

	^ startColor
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> startColor: anObject [

	startColor := anObject
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> widthMetric [

	^ widthMetric
]

{ #category : 'accessing' }
MiSystemComplexitySettingsMemento >> widthMetric: aFM3Property [

	widthMetric := aFM3Property
]
