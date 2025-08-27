Trait {
	#name : 'MiTSpecModelWithSettings',
	#category : 'MooseIDE-Core-Settings',
	#package : 'MooseIDE-Core',
	#tag : 'Settings'
}

{ #category : 'testing' }
MiTSpecModelWithSettings >> hasSettings [

	^ true
]

{ #category : 'settings management' }
MiTSpecModelWithSettings >> newMemento [

	self shouldBeImplemented
]

{ #category : 'settings management' }
MiTSpecModelWithSettings >> newMementoForDefaultValues [

	self shouldBeImplemented
]

{ #category : 'actions' }
MiTSpecModelWithSettings >> openSettings [

	^ (MiSettingsPresenter on: self) openDialog
]

{ #category : 'settings management' }
MiTSpecModelWithSettings >> settingsPresenterExtent [
	"Override to set a custom size"

	^ 350 @ 300
]

{ #category : 'settings management' }
MiTSpecModelWithSettings >> updateFromMemento: aMemento [

	self shouldBeImplemented
]
