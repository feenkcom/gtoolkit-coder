Class {
	#name : #GtPhlowSearchFilterTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'searchFilter'
	],
	#category : #'GToolkit-SearchFilters-PhlowTool'
}

{ #category : #'instance creation' }
GtPhlowSearchFilterTool class >> forSearchFilter: aSearchFilter [
	^ self new 
		searchFilter: aSearchFilter
]

{ #category : #'api - converting' }
GtPhlowSearchFilterTool >> asElementDo: aOneArgBlock [
	| toolElement |
	toolElement := GtPhlowSearchFilterToolElement new
		searchFilter: self searchFilter.
	^ aOneArgBlock cull: toolElement
]

{ #category : #'api - accessing' }
GtPhlowSearchFilterTool >> icon [
	"Return a tool icon"
	
	^ BrGlamorousVectorIcons search 
]

{ #category : #'api - accessing' }
GtPhlowSearchFilterTool >> name [
	"Return a tool name"

	^ 'Search Filter'
]

{ #category : #'api - accessing' }
GtPhlowSearchFilterTool >> object [
	^ self searchFilter
]

{ #category : #'api - accessing' }
GtPhlowSearchFilterTool >> object: aSearchFilter [
	self searchFilter:  aSearchFilter
]

{ #category : #accessing }
GtPhlowSearchFilterTool >> searchFilter [
	^ searchFilter
]

{ #category : #accessing }
GtPhlowSearchFilterTool >> searchFilter: aSearchFilter [
	searchFilter := aSearchFilter
]

{ #category : #'api - accessing' }
GtPhlowSearchFilterTool >> tabLook [
	^ BrGlamorousTabSwitcherWithIconAptitude
]
