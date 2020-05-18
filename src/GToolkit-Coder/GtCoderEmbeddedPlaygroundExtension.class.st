Class {
	#name : #GtCoderEmbeddedPlaygroundExtension,
	#superclass : #GtPagerPageEmbellisherExtension,
	#instVars : [
		'navigationModel',
		'playPage'
	],
	#category : #'GToolkit-Coder-Coder in Pager'
}

{ #category : #'widget configuration' }
GtCoderEmbeddedPlaygroundExtension >> fillToolWidgetIn: aCreationContext [
	"initialize a tool widget"
	| aStencil |
	aStencil := GEmbeddedPlaygroundStencil new
		receiver: self receiver;
		asChildIn: aCreationContext wrapperElement.
	self playPage: aStencil playPage.
	self hookToCoderSelections: nil.
]

{ #category : #hooks }
GtCoderEmbeddedPlaygroundExtension >> hookToCoderSelections: aPlayBook [
	self navigationModel 
		when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self;
		when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self;
		when: GtCoderNavigationTagSelected send: #onTagSelected: to: self;
		when: GtCoderNavigationClassSelected send: #onClassSelected: to: self.
]

{ #category : #accessing }
GtCoderEmbeddedPlaygroundExtension >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoderEmbeddedPlaygroundExtension >> navigationModel: anObject [
	navigationModel := anObject
]

{ #category : #hooks }
GtCoderEmbeddedPlaygroundExtension >> onClassSelected: anEvent [
	self playPage receiver: anEvent theClass
]

{ #category : #hooks }
GtCoderEmbeddedPlaygroundExtension >> onPackageSelected: anEvent [
	self playPage receiver: anEvent package
]

{ #category : #hooks }
GtCoderEmbeddedPlaygroundExtension >> onPackagesSelected: anEvent [
	self playPage receiver: Smalltalk 
]

{ #category : #hooks }
GtCoderEmbeddedPlaygroundExtension >> onTagSelected: anEvent [
	self playPage receiver: anEvent tag
]

{ #category : #accessing }
GtCoderEmbeddedPlaygroundExtension >> playPage [
	^ playPage
]

{ #category : #accessing }
GtCoderEmbeddedPlaygroundExtension >> playPage: anObject [
	playPage := anObject
]

{ #category : #'widget configuration' }
GtCoderEmbeddedPlaygroundExtension >> receiver [
	navigationModel selectedClassDo: [ :aClass | ^ aClass ].
	navigationModel selectedTagDo: [ :aPackageTag | ^ aPackageTag ].
	navigationModel selectedPackageDo: [ :aPackage | ^ aPackage ].
	^ Smalltalk
]
