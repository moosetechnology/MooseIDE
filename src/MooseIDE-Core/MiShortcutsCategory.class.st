Class {
	#name : #MiShortcutsCategory,
	#superclass : #KMCategory,
	#category : #'MooseIDE-Core-KeyMapping'
}

{ #category : #keymaps }
MiShortcutsCategory >> openModelRootBrowser [

	<shortcut>

	^ MiModelRootBrowser openShortcut
]
