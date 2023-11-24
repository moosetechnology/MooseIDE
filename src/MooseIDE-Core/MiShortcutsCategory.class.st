Class {
	#name : #MiShortcutsCategory,
	#superclass : #KMCategory,
	#category : #'MooseIDE-Core-KeyMapping'
}

{ #category : #testing }
MiShortcutsCategory class >> isGlobalCategory [

	^ true
]

{ #category : #'as yet unclassified' }
MiShortcutsCategory class >> openModelRootBrowser [

	<shortcut>
	^ MiModelRootBrowser openShortcut
]
