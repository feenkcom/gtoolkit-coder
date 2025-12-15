Class {
	#name : #GtTextualCoderSearchTextSettings,
	#superclass : #Object,
	#classVars : [
		'IsEnabledInCoder'
	],
	#category : 'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #settings }
GtTextualCoderSearchTextSettings class >> disableInCoder [
	IsEnabledInCoder := false
]

{ #category : #settings }
GtTextualCoderSearchTextSettings class >> enableInCoder [
	IsEnabledInCoder := true
]

{ #category : #settings }
GtTextualCoderSearchTextSettings class >> isEnabledInCoder [
	^ IsEnabledInCoder ifNil: [ true ]
]
