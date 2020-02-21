Class {
	#name : #MiObjectInspector,
	#superclass : #StObjectInspector,
	#category : #'Midas-Inspector'
}

{ #category : #commands }
MiObjectInspector class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	| group |
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	(StInspectorCommand toolbarCommandsFor: self)
		do: [ :cmd | group register: cmd ].
	group register: (MiPropagateCommand forSpecContext: presenter).
	aCmCommandsGroup register: group
	
]

{ #category : #initialization }
MiObjectInspector >> miSelectedItem [
	^ self model inspectedObject
]
