Class {
	#name : #MiSelectableSettingCommand,
	#superclass : #MiSettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiSelectableSettingCommand class >> defaultAction [

	^ [ :collection :context | context items: collection ]
]

{ #category : #'adding - removing' }
MiSelectableSettingCommand >> addItem: anObject [

	self context addItem: anObject
]

{ #category : #accessing }
MiSelectableSettingCommand >> allItems [

	^ {  }
]

{ #category : #building }
MiSelectableSettingCommand >> buildPresenter [

	^ MiSelectableSettingPresenter on: self
]

{ #category : #accessing }
MiSelectableSettingCommand >> currentValue [

	^ {  }
]

{ #category : #execution }
MiSelectableSettingCommand >> execute: aCollection [

	self context items: aCollection
]

{ #category : #'adding - removing' }
MiSelectableSettingCommand >> removeItem: anObject [

	self context removeItem: anObject
]
