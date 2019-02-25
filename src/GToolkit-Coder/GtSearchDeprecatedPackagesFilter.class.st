Class {
	#name : #GtSearchDeprecatedPackagesFilter,
	#superclass : #GtSearchPackagesFilter,
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #testing }
GtSearchDeprecatedPackagesFilter >> includesPackage: aPackage [
	^ aPackage isDeprecated
]
