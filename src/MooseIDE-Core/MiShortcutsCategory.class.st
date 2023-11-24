Class {
	#name : #MiShortcutsCategory,
	#superclass : #KMCategory,
	#category : #'MooseIDE-Core-KeyMapping'
}

{ #category : #testing }
MiShortcutsCategory class >> isGlobalCategory [

	^ true
]

{ #category : #keymaps }
MiShortcutsCategory >> openModelRootBrowser [

	<shortcut>

	^ MiModelRootBrowser openKeyMap
]
