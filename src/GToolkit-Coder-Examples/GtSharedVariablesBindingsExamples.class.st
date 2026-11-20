"
I exemplify {{gtClass:GtSharedVariablesBindings}}, the variables shared by the snippets of a playground or of a Lepiter page.
Variable names are Symbols, as the compiler looks them up. Names typed by users, such as the binding name of a Lepiter string snippet, are Strings: the bindings answer the same variable for both kinds of name.
"
Class {
	#name : #GtSharedVariablesBindingsExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Bindings'
}

{ #category : #examples }
GtSharedVariablesBindingsExamples >> bindingWithStringName [
	"A binding created with a typed (String) name is the variable the compiler finds by its Symbol"
	<gtExample>
	<return: #GtSharedVariablesBindings>
	| bindings binding |
	bindings := self emptyBindings.
	binding := bindings bindingOf: 'answer'.
	binding value: 42.
	self assert: (bindings bindingOf: #answer) == binding.
	self assert: bindings bindingNames asArray equals: #(#answer).
	self assert: bindings bindingNames anyOne isSymbol.
	self assert: (bindings hasBindingOf: 'answer').
	self assert: (bindings hasBindingOf: #answer).
	self assert: (bindings bindingValueOf: 'answer') equals: 42.
	^ bindings
]

{ #category : #examples }
GtSharedVariablesBindingsExamples >> emptyBindings [
	<gtExample>
	<return: #GtSharedVariablesBindings>
	| bindings |
	bindings := GtSharedVariablesBindings new.
	self assert: bindings bindingNames isEmpty.
	^ bindings
]

{ #category : #examples }
GtSharedVariablesBindingsExamples >> removeBindingWithStringName [
	"The bindings view and LeBindingNameUpdater remove bindings by a String name"
	<gtExample>
	<return: #GtSharedVariablesBindings>
	| bindings |
	bindings := self bindingWithStringName.
	bindings removeBindingOf: 'answer'.
	self assert: (bindings hasBindingOf: #answer) not.
	self assert: bindings bindingNames isEmpty.
	^ bindings
]
