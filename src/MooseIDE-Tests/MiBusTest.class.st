Class {
	#name : #MiBusTest,
	#superclass : #MiAbstractApplicationTest,
	#instVars : [
		'bus'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiBusTest >> mockBrowser [
	| mockBrowser |
	mockBrowser := Mock named: 'Mock browser'.
	"(mockBrowser stub selectEntity: (Instance of: MooseEntity))
		willReturn: MooseEntity new."
	^ mockBrowser
]

{ #category : #initialization }
MiBusTest >> setUp [
	  super setUp.

	  bus := self application defaultBus
]

{ #category : #running }
MiBusTest >> tearDown [

	self application class reset.
	super tearDown
]

{ #category : #tests }
MiBusTest >> testGloballySelect [
	| browser entity |
	
	browser := self mockBrowser.
	bus registerBrowser:  browser.
	
	entity := MooseEntity new.

	bus globallySelect: entity.
	self assert: bus logger mostRecentEntity identicalTo: entity.
	browser should receive receiveEntity: entity.
]

{ #category : #tests }
MiBusTest >> testRegisterBrowser [
	| browser |
	browser := self mockBrowser.
	bus registerBrowser: browser.
	self assert: (bus browsers includes: browser)
]

{ #category : #tests }
MiBusTest >> testUnregisterBrowser [
	| browser |
	browser := self mockBrowser.
	bus registerBrowser: browser.
	self assert: (bus browsers includes: browser).
	bus unregisterBrowser: browser.
	self deny: (bus browsers includes: browser)
]
