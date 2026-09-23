Class {
	#name : #MiDisplayedNameSettingPresenter,
	#superclass : #MiAbstractRadioButtonSettingPresenter,
	#category : #'MooseIDE-Visualization-System Complexity'
}

{ #category : #accessing }
MiDisplayedNameSettingPresenter class >> help [

	^ 'How should the entities name be computed?
- #name will display only the name of the class
- #mooseName will display all the containment branch with the form: ''TopContainer.TypeContainer.Class'' ]'
]

{ #category : #accessing }
MiDisplayedNameSettingPresenter class >> label [

	^ 'Name to display:'
]

{ #category : #'event handling' }
MiDisplayedNameSettingPresenter >> activate: aSymbol [

	configuration displayedName: aSymbol
]

{ #category : #adding }
MiDisplayedNameSettingPresenter >> addButton: aButton [

	self layout add: aButton width: 90
]

{ #category : #building }
MiDisplayedNameSettingPresenter >> helpForItem: aSymbol [

	^ aSymbol = #name
		  ifTrue: [ 'Display only the name of the class' ]
		  ifFalse: [
			  'Display all the containment branch with the form: ''TopContainer.TypeContainer.Class''' ]
]

{ #category : #testing }
MiDisplayedNameSettingPresenter >> isCurrentValue: aSymbol [

	^ aSymbol = configuration displayedName
]

{ #category : #accessing }
MiDisplayedNameSettingPresenter >> items [

	^ { #name. #mooseName }
]

{ #category : #building }
MiDisplayedNameSettingPresenter >> labelForItem: aSymbol [

	^ aSymbol asString
]
