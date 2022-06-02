Class {
	#name : #MiButtonCodeSettingItemTest,
	#superclass : #MiAbstractSettingItemTest,
	#category : #'MooseIDE-Tests-Settings'
}

{ #category : #running }
MiButtonCodeSettingItemTest >> initialValue [
	"some piece of code, whatever"
	^
'[ :arg |
	arg queryAllOutgoingAssociations
]'
]

{ #category : #running }
MiButtonCodeSettingItemTest >> settingItemInstance [
	^MiButtonCodeSettingItem new
]

{ #category : #running }
MiButtonCodeSettingItemTest >> someOtherValue [
	"another piece of code, whatever"
	^
'[ :arg |
	arg mooseModel allWithSubTypesOf: arg class
]'
]
