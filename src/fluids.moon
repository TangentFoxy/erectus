{
  earth: { A: 0.0069, H2O: 0.0039, CO2: 0.0004, Ne: 0.000015, N2: 0.779885, O2: 0.2089 }
  air: { N2: 0.78, O2: 0.22 }
  feces: {
    H2O: 0.75, organics: 0.25 * 0.335, C6H10O5: 0.25 * 0.335
    phosphates: 0.25 * 0.152, fats: 0.25 * 0.152, proteins: 0.25 * 0.026
  }
  urine: { H2O: 0.95, urea: 0.04, salts: 0.01 } -- sodium/potassium salts
  organics: {
    C: 0.504, O2: 0.202, N2: 0.141, H2: 0.081, P: 0.03, S: 0.01, K: 0.01, Mg: 0.005
    Ca: 0.005, Fe: 0.002, Mn: 0.001, Co: 0.001, Zn: 0.001, Cu: 0.001, Mo: 0.001
  }
  -- phosphates: { iron: 0.33, calcium: 0.33, phosphor: 0.34 }
  -- FePO4 & Ca3(PO4)2
}

-- C6 H10 O5 + 6x 02 -> 6x C 02 + 5x H2 0
-- 6 oxygen + 1 cellulose -> 6 carbon dioxide + 5 water
