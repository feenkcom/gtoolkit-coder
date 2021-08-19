Class {
	#name : 'GtCoderNavigationPackageSelected',
	#superclass : 'GtCoderNavigationSelectionAnnouncement',
	#instVars : [
		'package'
	],
	#category : 'GToolkit-Coder-Navigation - Events'
}

{ #category : 'accessing' }
GtCoderNavigationPackageSelected >> package [
	<return: #RPackage>

	^ package
]

{ #category : 'accessing' }
GtCoderNavigationPackageSelected >> package: anObject [
	package := anObject
]
