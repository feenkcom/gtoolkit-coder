Class {
	#name : #GtClassCoderPackagesFilterStringChanged,
	#superclass : #Announcement,
	#instVars : [
		'navigationModel',
		'packagesFilterString'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtClassCoderPackagesFilterStringChanged >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtClassCoderPackagesFilterStringChanged >> navigationModel: anObject [
	navigationModel := anObject
]

{ #category : #accessing }
GtClassCoderPackagesFilterStringChanged >> packagesFilterString [
	^ packagesFilterString
]

{ #category : #accessing }
GtClassCoderPackagesFilterStringChanged >> packagesFilterString: anObject [
	packagesFilterString := anObject
]
