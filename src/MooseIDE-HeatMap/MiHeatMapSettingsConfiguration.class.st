Class {
	#name : 'MiHeatMapSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'childrenTypeName',
		'childrenRecursive',
		'availableChildrenTypes',
		'startColor',
		'endColor',
		'colorBlockSource'
	],
	#category : 'MooseIDE-HeatMap-Settings',
	#package : 'MooseIDE-HeatMap',
	#tag : 'Settings'
}

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> availableChildrenTypes [

	^ availableChildrenTypes
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> availableChildrenTypes: anObject [

	availableChildrenTypes := anObject
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> childrenRecursive [

	^ childrenRecursive
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> childrenRecursive: anObject [

	childrenRecursive := anObject
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> childrenTypeName [

	^ childrenTypeName
]

{ #category : 'accessing' }
MiHeatMapSettingsConfiguration >> childrenTypeName: anObject [

	childrenTypeName := anObject
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
		  add: ((MiDroplistSettingPresenter on: self)
				   label: 'Children type:';
				   help:
					   'Famix type of the entities to show nested inside each propagated entity (e.g. Method, Attribute, Class).';
				   items: availableChildrenTypes;
				   selectItem: childrenTypeName;
				   whenSelectedDo: [ :typeName | self childrenTypeName: typeName ];
				   yourself);
		  add: ((MiBooleanSettingPresenter on: self)
				   label: 'Include all descendants (recursive)';
				   help:
					   'If checked, children are collected from the whole containment subtree instead of just the direct children.';
				   state: childrenRecursive;
				   whenStateChangedDo: [ :bool | self childrenRecursive: bool ];
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
