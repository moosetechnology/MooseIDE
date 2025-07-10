Class {
	#name : #MiSelectableSettingCommand,
	#superclass : #MiSettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiSelectableSettingCommand class >> defaultAction [

	^ [ :collection :context | context items: collection ]
]

{ #category : #private }
MiSelectableSettingCommand class >> defaultIcon [
	"Override to set a valuable used to get an icon for the selectable items"

	^ nil
]

{ #category : #'as yet unclassified' }
MiSelectableSettingCommand class >> defaultItemsDisplay [

	^ #printString
]

{ #category : #'adding - removing' }
MiSelectableSettingCommand >> addItem: anObject [

	self context addItem: anObject
]

{ #category : #accessing }
MiSelectableSettingCommand >> allItems [

	^ {  }
]

{ #category : #accessing }
MiSelectableSettingCommand >> currentValue [

	^ {  }
]

{ #category : #execution }
MiSelectableSettingCommand >> execute: aCollection [

	self context items: aCollection
]

{ #category : #accessing }
MiSelectableSettingCommand >> icon [

	^ self class defaultIcon
]

{ #category : #accessing }
MiSelectableSettingCommand >> itemsDisplay [

	^ self class defaultItemsDisplay
]

{ #category : #accessing }
MiSelectableSettingCommand >> presenterClass [

	^ MiSelectableSettingPresenter
]

{ #category : #'adding - removing' }
MiSelectableSettingCommand >> removeItem: anObject [

	self context removeItem: anObject
]
