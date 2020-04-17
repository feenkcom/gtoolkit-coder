Class {
	#name : #GtClassCoderPackagesTreeNavigation,
	#superclass : #GtClassCoderNavigationModel,
	#instVars : [
		'packagesFilterString'
	],
	#category : #'GToolkit-Coder-Navigation'
}

{ #category : #converting }
GtClassCoderPackagesTreeNavigation >> asElement [
	^ GtCoderNavigationPackagesTreeElement new
		navigationModel: self
]

{ #category : #accessing }
GtClassCoderPackagesTreeNavigation >> displayPosition [
	^ #left
]

{ #category : #initialization }
GtClassCoderPackagesTreeNavigation >> initialize [
	super initialize.
	packagesFilterString := ''
]

{ #category : #accessing }
GtClassCoderPackagesTreeNavigation >> packagesFilterString [
	^ packagesFilterString
]

{ #category : #accessing }
GtClassCoderPackagesTreeNavigation >> packagesFilterString: aString [
	self assert: [ aString isNotNil ].
	packagesFilterString := aString.
	self
		announce:
			(GtClassCoderPackagesFilterStringChanged new
				navigationModel: self;
				packagesFilterString: packagesFilterString;
				yourself)
]
