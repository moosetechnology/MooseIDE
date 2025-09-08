Class {
	#name : 'MiTagsSettingPresenter',
	#superclass : 'MiAbstractSelectableSettingPresenter',
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'initialization' }
MiTagsSettingPresenter class >> help [

	^ 'The selected tags will be represented as entities in the visualisation.
Inner elements will be the tagged entities'
]

{ #category : 'specs' }
MiTagsSettingPresenter class >> label [

	^ 'Show these tags as entities:'
]

{ #category : 'initialization' }
MiTagsSettingPresenter >> allItems [

	^ configuration availableTags
]

{ #category : 'initialization' }
MiTagsSettingPresenter >> displayItem: aTag [

	^ aTag name
]

{ #category : 'initialization' }
MiTagsSettingPresenter >> iconColumn [

	^ SpImageTableColumn evaluated: [ :tag |
		  self application iconForTag: tag ]
]

{ #category : 'initialization' }
MiTagsSettingPresenter >> selectAll [

	configuration tags: configuration availableTags
]

{ #category : 'api - selection' }
MiTagsSettingPresenter >> selectItem: aTag [

	configuration tags add: aTag
]

{ #category : 'initialization' }
MiTagsSettingPresenter >> selectNone [

	configuration tags: OrderedCollection new
]

{ #category : 'initialization' }
MiTagsSettingPresenter >> selectedItems [

	^ configuration tags
]

{ #category : 'api - selection' }
MiTagsSettingPresenter >> unselectItem: aTag [

	configuration tags remove: aTag
]
