"
Shared fixture/helper for tests that characterize a visualization builder's menuInteraction behaviour by driving it directly against a real browser and canvas.

Deliberately subclasses MiAbstractApplicationTest, not MiAbstractBrowserTest: the latter carries ~30 generic browser-behaviour tests (bus following, window title, tagging, settings dialogs...) that are irrelevant here, and at least one (testSettingsAction) actively fails without an override. This class defines no test* methods itself, so subclasses inherit none of that.

Subclasses override #browserClassToTest, then in their own #setUp (after calling super) populate `model` with a fixture, call `browser followEntity: ...`, send #rebuildVisualization, and extract whatever shapes they need from `canvas` as their own instance variables.
"
Class {
	#name : 'MiAbstractMenuBuildingTest',
	#superclass : 'MiAbstractApplicationTest',
	#instVars : [
		'browser',
		'builder',
		'canvas',
		'model'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiAbstractMenuBuildingTest >> browserClassToTest [

	^ self subclassResponsibility
]

{ #category : 'running' }
MiAbstractMenuBuildingTest >> buildMenuFor: aShape [
	"Drives the actual menuInteraction block rather than reconstructing its body.
	 RSMenuActivable exposes no public accessor for its menuBlock, so it's reached
	 reflectively; this avoids simulating a real RSMouseRightClick event and the
	 resulting menu popUpInWorld, which onShape: would otherwise require."

	| menu |
	menu := MenuMorph new.
	(builder menuInteraction instVarNamed: 'menuBlock')
		value: menu
		value: aShape.
	^ menu
]

{ #category : 'running' }
MiAbstractMenuBuildingTest >> rebuildVisualization [
	"followEntity: only triggers a rebuild via #changed: #applyScript,
	 so buildInCanvas: is called explicitly here instead of relying on notification's timing."

	browser visualization buildInCanvas: browser visualization canvas.
	builder := browser visualization builder.
	canvas := builder canvas
]

{ #category : 'running' }
MiAbstractMenuBuildingTest >> setUp [

	super setUp.
	browser := self browserClassToTest openForTests: application.
	model := FamixStModel new
]

{ #category : 'running' }
MiAbstractMenuBuildingTest >> tearDown [

	browser ifNotNil: [ browser withWindowDo: [ :window | window close ] ].
	super tearDown
]
