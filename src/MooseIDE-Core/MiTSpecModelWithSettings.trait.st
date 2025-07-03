Trait {
	#name : #MiTSpecModelWithSettings,
	#category : #'MooseIDE-Core-Browser'
}

{ #category : #settings }
MiTSpecModelWithSettings classSide >> mementoForDefaultValues [

	self shouldBeImplemented
]

{ #category : #settings }
MiTSpecModelWithSettings classSide >> settingsCommandsOn: aMemento [
	"Override to add  commands"

	^ OrderedCollection new
]

{ #category : #testing }
MiTSpecModelWithSettings >> hasSettings [

	^ true
]

{ #category : #'settings management' }
MiTSpecModelWithSettings >> newMemento [

	self shouldBeImplemented
]

{ #category : #'settings management' }
MiTSpecModelWithSettings >> newMementoForDefaultValues [

	^ self class mementoForDefaultValues
]

{ #category : #actions }
MiTSpecModelWithSettings >> openSettings [

	^ (MiSettingsPresenter on: self) openDialog
]

{ #category : #'settings management' }
MiTSpecModelWithSettings >> settingsCommandsOn: aMemento [

	^ self class settingsCommandsOn: aMemento
]

{ #category : #'settings management' }
MiTSpecModelWithSettings >> updateFromMemento: aMemento [

	self shouldBeImplemented
]
