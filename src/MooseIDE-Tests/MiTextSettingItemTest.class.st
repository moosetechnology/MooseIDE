Class {
	#name : #MiTextSettingItemTest,
	#superclass : #MiAbstractSettingItemTest,
	#category : #'MooseIDE-Tests-Settings'
}

{ #category : #running }
MiTextSettingItemTest >> initialValue [
	^'Initial Value'
]

{ #category : #running }
MiTextSettingItemTest >> settingItemInstance [
	^MiTextSettingItem new
]

{ #category : #running }
MiTextSettingItemTest >> someOtherValue [
	^'Some Other Value'
]

{ #category : #tests }
MiTextSettingItemTest >> testDateValue [
	settingItem setValue: '22 February 2022'.
	self assert: settingItem getValue equals: '22 February 2022'.

	settingItem dateValue.
	self assert: settingItem getValue equals: (Date year: 2022 month: 02 day: 22)
]

{ #category : #tests }
MiTextSettingItemTest >> testFloatValue [
	settingItem setValue: '4.2'.
	self assert: settingItem getValue equals: '4.2'.

	settingItem floatValue.
	self assert: settingItem getValue equals: 4.2
]

{ #category : #tests }
MiTextSettingItemTest >> testIntegerValue [
	settingItem setValue: '42'.
	self assert: settingItem getValue equals: '42'.

	settingItem integerValue.
	self assert: settingItem getValue equals: 42
]
