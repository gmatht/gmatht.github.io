/* tslint:disable */
/* eslint-disable */
export function init_panic_hook(): void;
export class Debashc {
  free(): void;
  constructor();
  /**
   * Tokenize a shell script
   */
  lex(input: string): string;
  /**
   * Parse a shell script to AST
   */
  parse(input: string): string;
  /**
   * Convert shell script to Perl
   */
  to_perl(input: string): string;
  /**
   * Convert shell script to Rust
   */
  to_rust(input: string): string;
  /**
   * Convert shell script to Python
   */
  to_python(input: string): string;
  /**
   * Convert shell script to Lua
   */
  to_lua(input: string): string;
  /**
   * Convert shell script to C
   */
  to_c(input: string): string;
  /**
   * Convert shell script to JavaScript
   */
  to_js(input: string): string;
  /**
   * Convert shell script to English pseudocode
   */
  to_english(input: string): string;
  /**
   * Convert shell script to French pseudocode
   */
  to_french(input: string): string;
  /**
   * Convert shell script to Windows Batch
   */
  to_bat(input: string): string;
  /**
   * Convert shell script to PowerShell
   */
  to_ps(input: string): string;
}

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly __wbg_debashc_free: (a: number, b: number) => void;
  readonly debashc_new: () => number;
  readonly debashc_lex: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_parse: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_perl: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_rust: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_python: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_lua: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_c: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_js: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_english: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_french: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_bat: (a: number, b: number, c: number) => [number, number, number, number];
  readonly debashc_to_ps: (a: number, b: number, c: number) => [number, number, number, number];
  readonly init_panic_hook: () => void;
  readonly __wbindgen_free: (a: number, b: number, c: number) => void;
  readonly __wbindgen_malloc: (a: number, b: number) => number;
  readonly __wbindgen_realloc: (a: number, b: number, c: number, d: number) => number;
  readonly __wbindgen_export_3: WebAssembly.Table;
  readonly __externref_table_dealloc: (a: number) => void;
  readonly __wbindgen_start: () => void;
}

export type SyncInitInput = BufferSource | WebAssembly.Module;
/**
* Instantiates the given `module`, which can either be bytes or
* a precompiled `WebAssembly.Module`.
*
* @param {{ module: SyncInitInput }} module - Passing `SyncInitInput` directly is deprecated.
*
* @returns {InitOutput}
*/
export function initSync(module: { module: SyncInitInput } | SyncInitInput): InitOutput;

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {{ module_or_path: InitInput | Promise<InitInput> }} module_or_path - Passing `InitInput` directly is deprecated.
*
* @returns {Promise<InitOutput>}
*/
export default function __wbg_init (module_or_path?: { module_or_path: InitInput | Promise<InitInput> } | InitInput | Promise<InitInput>): Promise<InitOutput>;
