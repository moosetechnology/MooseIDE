Class {
	#name : #MiBusTest,
	#superclass : #TestCase,
	#instVars : [
		'bus'
	],
	#category : #'MooseIDE-Tests-Application'
}

{ #category : #running }
MiBusTest >> application [
	^ MiTestApplication current
]

{ #category : #running }
MiBusTest >> mockBrowser [
	| mockBrowser |
	mockBrowser := Mock named: 'Mock browser'.
	"(mockBrowser stub selectEntity: (Instance of: MooseEntity))
		willReturn: MooseEntity new."
	^ mockBrowser
]

{ #category : #running }
MiBusTest >> setUp [
	super setUp.
	bus := self application defaultBus
]

{ #category : #running }
MiBusTest >> tearDown [
	self application deleteBus: bus.
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
	browser should receive selectEntity: entity.
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
