Class {
	#name : 'MiDistributionMapSettingsConfiguration',
	#superclass : 'MiAbstractSettingsConfiguration',
	#instVars : [
		'baseColor',
		'childrenQuery',
		'tags',
		'availableTags'
	],
	#category : 'MooseIDE-Dependency-DistributionMap',
	#package : 'MooseIDE-Dependency',
	#tag : 'DistributionMap'
}

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> availableTags [

	^ availableTags
]

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> availableTags: anObject [

	availableTags := anObject
]

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> baseColor [

	^ baseColor
]

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> baseColor: anObject [

	baseColor := anObject
]

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> childrenQuery [

	^ childrenQuery
]

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> childrenQuery: anObject [

	childrenQuery := anObject
]

{ #category : 'ui' }
MiDistributionMapSettingsConfiguration >> settingsPresenters [

	^ super settingsPresenters
		  add: ((MiQuerySettingPresenter on: self)
				   beForChildren;
				   yourself);
		  add: ((MiTagsSettingPresenter on: self)
				   label: 'Tags:';
				   help: 'The tags used as properties to display.
If an entity has several tags, it will get the color of the first of its tags appearing in the list';
				   yourself);
		  add: ((MiColorSelectionPresenter on: self)
				   color: baseColor;
				   whenColorChangedDo: [ :newColor | self baseColor: newColor ];
				   label: 'Default entity color:';
				   help: 'Color used when no property applies to an entity');
		  yourself
]

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> tags [

	^ tags
]

{ #category : 'accessing' }
MiDistributionMapSettingsConfiguration >> tags: anObject [

	tags := anObject
]
