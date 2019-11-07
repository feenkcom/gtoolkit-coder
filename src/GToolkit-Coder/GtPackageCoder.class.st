Class {
	#name : #GtPackageCoder,
	#superclass : #Announcer,
	#instVars : [
		'package',
		'classesCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #elements }
GtPackageCoder >> asElement [
	^ GtPackageCoderElement new packageCoder: self
]

{ #category : #accessing }
GtPackageCoder >> classesCoder [
	^ classesCoder
]

{ #category : #initialization }
GtPackageCoder >> initialize [
	super initialize.
	classesCoder := GtClassesCoder new
]

{ #category : #accessing }
GtPackageCoder >> package [
	^ package
]

{ #category : #accessing }
GtPackageCoder >> package: aRPackage [
	package := aRPackage.
	classesCoder forPackage: aRPackage
]
