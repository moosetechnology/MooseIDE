Class {
	#name : 'MiHeatMapSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'childrenQuery',
		'startColor',
		'endColor',
		'colorBlockSource'
	],
	#category : 'MooseIDE-HeatMap-Settings',
	#package : 'MooseIDE-HeatMap',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> childrenQuery [

	^ childrenQuery
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> childrenQuery: anObject [

	childrenQuery := anObject
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> colorBlockSource [

	^ colorBlockSource
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> colorBlockSource: anObject [

	colorBlockSource := anObject
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> endColor [

	^ endColor
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> endColor: anObject [

	endColor := anObject
]

{ #category : 'ui' }
MiHeatMapSettingsConfiguration >> settingsPresenters [

	^ super settingsPresenters
		  add: ((MiQuerySettingPresenter on: self)
				   beForChildren;
				   yourself);
		  add: (MiColorGradientSettingPresenter on: self);
		  add: ((MiBlockSettingPresenter on: self)
				   label: 'Color value block:';
				   help:
					   'A one-argument Pharo block computing a numeric value for each entity. Values are linearly scaled between the two colors above. Example: [ :entity | entity numberOfMethods ]';
				   yourself);
		  yourself
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> startColor [

	^ startColor
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> startColor: anObject [

	startColor := anObject
]
