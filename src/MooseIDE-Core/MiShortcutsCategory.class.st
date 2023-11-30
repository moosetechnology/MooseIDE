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

	^ MiModelsBrowser openKeyMap
]

{ #category : #keymaps }
MiShortcutsCategory >> openQueriesBrowser [

	<shortcut>

	^ MiQueriesBrowser openKeyMap
]

{ #category : #keymaps }
MiShortcutsCategory >> openTagBrowser [

	<shortcut>

	^ MiTagBrowser openKeyMap
]
