"
A MiSettingItem which value is given by a selectable list. It allows to select list of elements from a set of elements (all possible values).
"
Class {
	#name : #MiButtonSelectableListSettingItem,
	#superclass : #MiButtonSettingItem,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #accessing }
MiButtonSelectableListSettingItem >> getValue [

	^ secondaryPresenter selectedItems asOrderedCollection
]

{ #category : #initialization }
MiButtonSelectableListSettingItem >> initializeSecondaryPresenter [

	secondaryPresenter := SpFilteringSelectableListPresenter new.
]

{ #category : #accessing }
MiButtonSelectableListSettingItem >> possibleValues [

	^ secondaryPresenter items
]

{ #category : #accessing }
MiButtonSelectableListSettingItem >> possibleValues: aCollection [

	secondaryPresenter items: aCollection
]

{ #category : #accessing }
MiButtonSelectableListSettingItem >> selectAll [

	secondaryPresenter activateAll
]

{ #category : #accessing }
MiButtonSelectableListSettingItem >> setValue: aCollection [

	secondaryPresenter selectItems: aCollection
]
