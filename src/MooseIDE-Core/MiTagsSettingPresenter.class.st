Class {
	#name : #MiTagsSettingPresenter,
	#superclass : #MiAbstractSelectableSettingPresenter,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #initialization }
MiTagsSettingPresenter class >> help [

	^ 'The selected tags will be represented as entities in the visualisation.
Inner elements will be the tagged entities'
]

{ #category : #specs }
MiTagsSettingPresenter class >> label [

	^ 'Show these tags as entities:'
]

{ #category : #initialization }
MiTagsSettingPresenter >> allItems [

	^ memento availableTags
]

{ #category : #initialization }
MiTagsSettingPresenter >> displayItem: aTag [

	^ aTag name
]

{ #category : #initialization }
MiTagsSettingPresenter >> iconColumn [

	^ SpImageTableColumn evaluated: [ :tag |
		  self application iconForTag: tag ]
]

{ #category : #initialization }
MiTagsSettingPresenter >> selectAll [

	memento tags: memento availableTags
]

{ #category : #'api - selection' }
MiTagsSettingPresenter >> selectItem: aTag [

	memento tags add: aTag
]

{ #category : #initialization }
MiTagsSettingPresenter >> selectNone [

	memento tags: OrderedCollection new
]

{ #category : #initialization }
MiTagsSettingPresenter >> selectedItems [

	^ memento tags
]

{ #category : #'api - selection' }
MiTagsSettingPresenter >> unselectItem: aTag [

	memento tags remove: aTag
]
