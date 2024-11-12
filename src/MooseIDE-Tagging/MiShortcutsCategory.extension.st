Extension { #name : #MiShortcutsCategory }

{ #category : #'*MooseIDE-Tagging' }
MiShortcutsCategory >> openAnalysisBrowser [

	<shortcut>
	^ MiAnalysisPresenter openKeyMap
]

{ #category : #'*MooseIDE-Tagging' }
MiShortcutsCategory >> openTagBrowser [

	<shortcut>

	^ MiTagBrowser openKeyMap
]
